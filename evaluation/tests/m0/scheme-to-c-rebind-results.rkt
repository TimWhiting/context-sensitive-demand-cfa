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

'(query:
  (let (...
        ()
        (_ (-> (app analyze-mutable-variables input-program) <-))
        ()
        ...)
    ...)
  (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥)

'(query:
  (let (...
        ()
        (_ (-> (app set! input-program (app desugar input-program)) <-))
        ()
        ...)
    ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    allocate-environment
    (get-environment (-> (λ (id) ...) <-))
    closure-convert
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    allocate-environment
    (get-environment (-> (λ (id) ...) <-))
    closure-convert
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    allocate-lambda
    (get-lambda (-> (λ (id) ...) <-))
    c-compile-closure
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    allocate-lambda
    (get-lambda (-> (λ (id) ...) <-))
    c-compile-closure
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    analyze-mutable-variables
    (wrap-mutables (-> (λ (exp) ...) <-))
    mangle
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    analyze-mutable-variables
    (wrap-mutables (-> (λ (exp) ...) <-))
    mangle
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    assq-remove-key
    (assq-remove-keys (-> (λ (env keys) ...) <-))
    const?
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    assq-remove-key
    (assq-remove-keys (-> (λ (env keys) ...) <-))
    const?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    c-compile-app
    (c-compile-if (-> (λ (exp append-preamble) ...) <-))
    c-compile-set-cell!
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-app
    (c-compile-if (-> (λ (exp append-preamble) ...) <-))
    c-compile-set-cell!
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    c-compile-args
    (c-compile-app (-> (λ (exp append-preamble) ...) <-))
    c-compile-if
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-args
    (c-compile-app (-> (λ (exp append-preamble) ...) <-))
    c-compile-if
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    c-compile-cell
    (c-compile-env-make (-> (λ (exp append-preamble) ...) <-))
    c-compile-env-get
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-cell
    (c-compile-env-make (-> (λ (exp append-preamble) ...) <-))
    c-compile-env-get
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    c-compile-cell-get
    (c-compile-cell (-> (λ (exp append-preamble) ...) <-))
    c-compile-env-make
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-cell-get
    (c-compile-cell (-> (λ (exp append-preamble) ...) <-))
    c-compile-env-make
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    c-compile-closure
    (c-compile-formals (-> (λ (formals) ...) <-))
    c-compile-lambda
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-closure
    (c-compile-formals (-> (λ (formals) ...) <-))
    c-compile-lambda
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    c-compile-env-make
    (c-compile-env-get (-> (λ (exp append-preamble) ...) <-))
    num-lambdas
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-env-make
    (c-compile-env-get (-> (λ (exp append-preamble) ...) <-))
    num-lambdas
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    c-compile-env-struct
    (emit (-> (λ (line) ...) <-))
    c-compile-and-emit
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-env-struct
    (emit (-> (λ (line) ...) <-))
    c-compile-and-emit
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    c-compile-exp
    (c-compile-const (-> (λ (exp) ...) <-))
    c-compile-prim
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-exp
    (c-compile-const (-> (λ (exp) ...) <-))
    c-compile-prim
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    c-compile-formals
    (c-compile-lambda (-> (λ (exp) ...) <-))
    c-compile-env-struct
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-formals
    (c-compile-lambda (-> (λ (exp) ...) <-))
    c-compile-env-struct
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    c-compile-if
    (c-compile-set-cell! (-> (λ (exp append-preamble) ...) <-))
    c-compile-cell-get
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-if
    (c-compile-set-cell! (-> (λ (exp append-preamble) ...) <-))
    c-compile-cell-get
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    c-compile-prim
    (c-compile-ref (-> (λ (exp) ...) <-))
    c-compile-args
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-prim
    (c-compile-ref (-> (λ (exp) ...) <-))
    c-compile-args
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    c-compile-program
    (c-compile-exp (-> (λ (exp append-preamble) ...) <-))
    c-compile-const
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-program
    (c-compile-exp (-> (λ (exp append-preamble) ...) <-))
    c-compile-const
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    c-compile-ref
    (c-compile-args (-> (λ (args append-preamble) ...) <-))
    c-compile-app
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-ref
    (c-compile-args (-> (λ (args append-preamble) ...) <-))
    c-compile-app
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    c-compile-set-cell!
    (c-compile-cell-get (-> (λ (exp append-preamble) ...) <-))
    c-compile-cell
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-set-cell!
    (c-compile-cell-get (-> (λ (exp append-preamble) ...) <-))
    c-compile-cell
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    cell-get->cell
    (substitute-var (-> (λ (env var) ...) <-))
    substitute
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    cell-get->cell
    (substitute-var (-> (λ (env var) ...) <-))
    substitute
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    char->natural
    (integer->char-list (-> (λ (n) ...) <-))
    gensym-count
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    char->natural
    (integer->char-list (-> (λ (n) ...) <-))
    gensym-count
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    closure-convert
    (c-compile-program (-> (λ (exp) ...) <-))
    c-compile-exp
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    closure-convert
    (c-compile-program (-> (λ (exp) ...) <-))
    c-compile-exp
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

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
  (letrec*
   (...
    env-make->id
    (env-make->fields (-> (λ (exp) ...) <-))
    env-make->values
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    env-make->id
    (env-make->fields (-> (λ (exp) ...) <-))
    env-make->values
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    environments
    (allocate-environment (-> (λ (fields) ...) <-))
    get-environment
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    environments
    (allocate-environment (-> (λ (fields) ...) <-))
    get-environment
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    get-environment
    (closure-convert (-> (λ (exp) ...) <-))
    c-compile-program
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    get-environment
    (closure-convert (-> (λ (exp) ...) <-))
    c-compile-program
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    get-lambda
    (c-compile-closure (-> (λ (exp append-preamble) ...) <-))
    c-compile-formals
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    get-lambda
    (c-compile-closure (-> (λ (exp append-preamble) ...) <-))
    c-compile-formals
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    is-mutable?
    (analyze-mutable-variables (-> (λ (exp) ...) <-))
    wrap-mutables
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    is-mutable?
    (analyze-mutable-variables (-> (λ (exp) ...) <-))
    wrap-mutables
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    letrec->bindings
    (letrec->exp (-> (λ (exp) ...) <-))
    letrec->bound-vars
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    letrec->bindings
    (letrec->exp (-> (λ (exp) ...) <-))
    letrec->bound-vars
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    letrec->exp
    (letrec->bound-vars (-> (λ (exp) ...) <-))
    letrec->args
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    letrec->exp
    (letrec->bound-vars (-> (λ (exp) ...) <-))
    letrec->args
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    mark-mutable
    (is-mutable? (-> (λ (symbol) ...) <-))
    analyze-mutable-variables
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    mark-mutable
    (is-mutable? (-> (λ (symbol) ...) <-))
    analyze-mutable-variables
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    mutable-variables
    (mark-mutable (-> (λ (symbol) ...) <-))
    is-mutable?
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    mutable-variables
    (mark-mutable (-> (λ (symbol) ...) <-))
    is-mutable?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    num-environments
    (environments (-> (app nil) <-))
    allocate-environment
    ...)
   ...)
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    set-cell!?
    (set-cell!->cell (-> (λ (exp) ...) <-))
    set-cell!->value
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    set-cell!?
    (set-cell!->cell (-> (λ (exp) ...) <-))
    set-cell!->value
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (...
    tagged-list?
    (char->natural (-> (λ (c) ...) <-))
    integer->char-list
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    tagged-list?
    (char->natural (-> (λ (c) ...) <-))
    integer->char-list
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... azip (assq-remove-key (-> (λ (env key) ...) <-)) assq-remove-keys ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... azip (assq-remove-key (-> (λ (env key) ...) <-)) assq-remove-keys ...)
   ...)
  (env ()))
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
   (... c-compile-const (c-compile-prim (-> (λ (p) ...) <-)) c-compile-ref ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... c-compile-const (c-compile-prim (-> (λ (p) ...) <-)) c-compile-ref ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... c-compile-lambda (c-compile-env-struct (-> (λ (env) ...) <-)) emit ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... c-compile-lambda (c-compile-env-struct (-> (λ (env) ...) <-)) emit ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... cell->value (cell-get? (-> (λ (exp) ...) <-)) cell-get->cell ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... cell->value (cell-get? (-> (λ (exp) ...) <-)) cell-get->cell ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... cell-get? (cell-get->cell (-> (λ (exp) ...) <-)) substitute-var ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... cell-get? (cell-get->cell (-> (λ (exp) ...) <-)) substitute-var ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... closure->env (env-make? (-> (λ (exp) ...) <-)) env-make->id ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... closure->env (env-make? (-> (λ (exp) ...) <-)) env-make->id ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... closure->lam (closure->env (-> (λ (exp) ...) <-)) env-make? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... closure->lam (closure->env (-> (λ (exp) ...) <-)) env-make? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... closure? (closure->lam (-> (λ (exp) ...) <-)) closure->env ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... closure? (closure->lam (-> (λ (exp) ...) <-)) closure->env ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... desugar (free-vars (-> (λ (exp) ...) <-)) mutable-variables ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... desugar (free-vars (-> (λ (exp) ...) <-)) mutable-variables ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... env-get->env (set-cell!? (-> (λ (exp) ...) <-)) set-cell!->cell ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... env-get->env (set-cell!? (-> (λ (exp) ...) <-)) set-cell!->cell ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... env-get->field (env-get->env (-> (λ (exp) ...) <-)) set-cell!? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... env-get->field (env-get->env (-> (λ (exp) ...) <-)) set-cell!? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... env-get->id (env-get->field (-> (λ (exp) ...) <-)) env-get->env ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... env-get->id (env-get->field (-> (λ (exp) ...) <-)) env-get->env ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... env-get? (env-get->id (-> (λ (exp) ...) <-)) env-get->field ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... env-get? (env-get->id (-> (λ (exp) ...) <-)) env-get->field ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... env-make->fields (env-make->values (-> (λ (exp) ...) <-)) env-get? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... env-make->fields (env-make->values (-> (λ (exp) ...) <-)) env-get? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... env-make->values (env-get? (-> (λ (exp) ...) <-)) env-get->id ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... env-make->values (env-get? (-> (λ (exp) ...) <-)) env-get->id ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... env-make? (env-make->id (-> (λ (exp) ...) <-)) env-make->fields ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... env-make? (env-make->id (-> (λ (exp) ...) <-)) env-make->fields ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... for-each (append (-> (λ (lst1 lst2) ...) <-)) string->list ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... for-each (append (-> (λ (lst1 lst2) ...) <-)) string->list ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... free-vars (mutable-variables (-> (app nil) <-)) mark-mutable ...)
   ...)
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... if->condition (if->then (-> (λ (exp) ...) <-)) if->else ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... if->condition (if->then (-> (λ (exp) ...) <-)) if->else ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... lambda->formals (lambda->exp (-> (λ (exp) ...) <-)) if? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... lambda->formals (lambda->exp (-> (λ (exp) ...) <-)) if? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... lambda? (lambda->formals (-> (λ (exp) ...) <-)) lambda->exp ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... lambda? (lambda->formals (-> (λ (exp) ...) <-)) lambda->exp ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... lambdas (allocate-lambda (-> (λ (lam) ...) <-)) get-lambda ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... lambdas (allocate-lambda (-> (λ (lam) ...) <-)) get-lambda ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... let->args (letrec? (-> (λ (exp) ...) <-)) letrec->bindings ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... let->args (letrec? (-> (λ (exp) ...) <-)) letrec->bindings ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... let->bindings (let->exp (-> (λ (exp) ...) <-)) let->bound-vars ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... let->bindings (let->exp (-> (λ (exp) ...) <-)) let->bound-vars ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... let->bound-vars (let->args (-> (λ (exp) ...) <-)) letrec? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... let->bound-vars (let->args (-> (λ (exp) ...) <-)) letrec? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... let->exp (let->bound-vars (-> (λ (exp) ...) <-)) let->args ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... let->exp (let->bound-vars (-> (λ (exp) ...) <-)) let->args ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... let=>lambda (letrec=>lets+sets (-> (λ (exp) ...) <-)) begin=>let ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... let=>lambda (letrec=>lets+sets (-> (λ (exp) ...) <-)) begin=>let ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... letrec->args (lambda? (-> (λ (exp) ...) <-)) lambda->formals ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... letrec->args (lambda? (-> (λ (exp) ...) <-)) lambda->formals ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... letrec->bound-vars (letrec->args (-> (λ (exp) ...) <-)) lambda? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... letrec->bound-vars (letrec->args (-> (λ (exp) ...) <-)) lambda? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... letrec=>lets+sets (begin=>let (-> (λ (exp) ...) <-)) desugar ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... letrec=>lets+sets (begin=>let (-> (λ (exp) ...) <-)) desugar ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... letrec? (letrec->bindings (-> (λ (exp) ...) <-)) letrec->exp ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... letrec? (letrec->bindings (-> (λ (exp) ...) <-)) letrec->exp ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... num-lambdas (lambdas (-> (app nil) <-)) allocate-lambda ...)
   ...)
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... reduce (azip (-> (λ (list1 list2) ...) <-)) assq-remove-key ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... reduce (azip (-> (λ (list1 list2) ...) <-)) assq-remove-key ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... set!->exp (closure? (-> (λ (exp) ...) <-)) closure->lam ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... set!->exp (closure? (-> (λ (exp) ...) <-)) closure->lam ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... set-cell!->cell (set-cell!->value (-> (λ (exp) ...) <-)) cell? ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... set-cell!->cell (set-cell!->value (-> (λ (exp) ...) <-)) cell? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... set-cell!->value (cell? (-> (λ (exp) ...) <-)) cell->value ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... set-cell!->value (cell? (-> (λ (exp) ...) <-)) cell->value ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... substitute (let=>lambda (-> (λ (exp) ...) <-)) letrec=>lets+sets ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... substitute (let=>lambda (-> (λ (exp) ...) <-)) letrec=>lets+sets ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... substitute-var (substitute (-> (λ (env exp) ...) <-)) let=>lambda ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... substitute-var (substitute (-> (λ (env exp) ...) <-)) let=>lambda ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... void (tagged-list? (-> (λ (tag l) ...) <-)) char->natural ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... void (tagged-list? (-> (λ (tag l) ...) <-)) char->natural ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (... wrap-mutables (mangle (-> (λ (symbol) ...) <-)) num-environments ...)
   ...)
  (env ()))
clos/con:
	'((letrec*
   (... wrap-mutables (mangle (-> (λ (symbol) ...) <-)) num-environments ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec*
   (car ... the-benchmark-program)
   (-> (app c-compile-and-emit emit the-benchmark-program) <-))
  (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... app->args (prim? (-> (λ (exp) ...) <-)) begin? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... app->args (prim? (-> (λ (exp) ...) <-)) begin? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... app->fun (app->args (-> (λ (exp) ...) <-)) prim? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... app->fun (app->args (-> (λ (exp) ...) <-)) prim? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... app? (app->fun (-> (λ (exp) ...) <-)) app->args ...) ...)
  (env ()))
clos/con:
	'((letrec* (... app? (app->fun (-> (λ (exp) ...) <-)) app->args ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... append (string->list (-> (λ (s) ...) <-)) apply ...) ...)
  (env ()))
clos/con:
	'((letrec* (... append (string->list (-> (λ (s) ...) <-)) apply ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... apply (assv (-> (λ (x f) ...) <-)) assq ...) ...)
  (env ()))
clos/con:
	'((letrec* (... apply (assv (-> (λ (x f) ...) <-)) assq ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... assq (void (-> (λ () ...) <-)) tagged-list? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... assq (void (-> (λ () ...) <-)) tagged-list? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... assq-remove-keys (const? (-> (λ (exp) ...) <-)) ref? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... assq-remove-keys (const? (-> (λ (exp) ...) <-)) ref? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... assv (assq (-> (λ (x f) ...) <-)) void ...) ...)
  (env ()))
clos/con:
	'((letrec* (... assv (assq (-> (λ (x f) ...) <-)) void ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... begin->exps (set!? (-> (λ (exp) ...) <-)) set!->var ...) ...)
  (env ()))
clos/con:
	'((letrec* (... begin->exps (set!? (-> (λ (exp) ...) <-)) set!->var ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... begin? (begin->exps (-> (λ (exp) ...) <-)) set!? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... begin? (begin->exps (-> (λ (exp) ...) <-)) set!? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... c-compile-env-get (num-lambdas (-> 0 <-)) lambdas ...) ...)
  (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (letrec* (... caadr (caddr (-> (λ (p) ...) <-)) cadddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... caadr (caddr (-> (λ (p) ...) <-)) cadddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... cadddr (map (-> (λ (f lst) ...) <-)) for-each ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadddr (map (-> (λ (f lst) ...) <-)) for-each ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... caddr (cadddr (-> (λ (p) ...) <-)) map ...) ...)
  (env ()))
clos/con:
	'((letrec* (... caddr (cadddr (-> (λ (p) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... cadr (cddr (-> (λ (p) ...) <-)) caadr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadr (cddr (-> (λ (p) ...) <-)) caadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... cddr (caadr (-> (λ (p) ...) <-)) caddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cddr (caadr (-> (λ (p) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... cell? (cell->value (-> (λ (exp) ...) <-)) cell-get? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cell? (cell->value (-> (λ (exp) ...) <-)) cell-get? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... const? (ref? (-> (λ (exp) ...) <-)) let? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... const? (ref? (-> (λ (exp) ...) <-)) let? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... difference (reduce (-> (λ (f lst init) ...) <-)) azip ...) ...)
  (env ()))
clos/con:
	'((letrec* (... difference (reduce (-> (λ (f lst init) ...) <-)) azip ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... gensym (member (-> (λ (sym S) ...) <-)) symbol<? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... gensym (member (-> (λ (sym S) ...) <-)) symbol<? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... gensym-count (gensym (-> (λ (name) ...) <-)) member ...) ...)
  (env ()))
clos/con:
	'((letrec* (... gensym-count (gensym (-> (λ (name) ...) <-)) member ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... if->else (app? (-> (λ (exp) ...) <-)) app->fun ...) ...)
  (env ()))
clos/con:
	'((letrec* (... if->else (app? (-> (λ (exp) ...) <-)) app->fun ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... if->then (if->else (-> (λ (exp) ...) <-)) app? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... if->then (if->else (-> (λ (exp) ...) <-)) app? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... if? (if->condition (-> (λ (exp) ...) <-)) if->then ...) ...)
  (env ()))
clos/con:
	'((letrec* (... if? (if->condition (-> (λ (exp) ...) <-)) if->then ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... insert (remove (-> (λ (sym S) ...) <-)) union ...) ...)
  (env ()))
clos/con:
	'((letrec* (... insert (remove (-> (λ (sym S) ...) <-)) union ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... integer->char-list (gensym-count (-> 0 <-)) gensym ...) ...)
  (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (letrec* (... lambda->exp (if? (-> (λ (exp) ...) <-)) if->condition ...) ...)
  (env ()))
clos/con:
	'((letrec* (... lambda->exp (if? (-> (λ (exp) ...) <-)) if->condition ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... let? (let->bindings (-> (λ (exp) ...) <-)) let->exp ...) ...)
  (env ()))
clos/con:
	'((letrec* (... let? (let->bindings (-> (λ (exp) ...) <-)) let->exp ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... mangle (num-environments (-> 0 <-)) environments ...) ...)
  (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(query:
  (letrec* (... map (for-each (-> (λ (f lst) ...) <-)) append ...) ...)
  (env ()))
clos/con:
	'((letrec* (... map (for-each (-> (λ (f lst) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... member (symbol<? (-> (λ (sym1 sym2) ...) <-)) insert ...) ...)
  (env ()))
clos/con:
	'((letrec* (... member (symbol<? (-> (λ (sym1 sym2) ...) <-)) insert ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... null? (cadr (-> (λ (p) ...) <-)) cddr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... null? (cadr (-> (λ (p) ...) <-)) cddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) cadr ...) ...)
  (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) cadr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... prim? (begin? (-> (λ (exp) ...) <-)) begin->exps ...) ...)
  (env ()))
clos/con:
	'((letrec* (... prim? (begin? (-> (λ (exp) ...) <-)) begin->exps ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... ref? (let? (-> (λ (exp) ...) <-)) let->bindings ...) ...)
  (env ()))
clos/con:
	'((letrec* (... ref? (let? (-> (λ (exp) ...) <-)) let->bindings ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... remove (union (-> (λ (set1 set2) ...) <-)) difference ...) ...)
  (env ()))
clos/con:
	'((letrec* (... remove (union (-> (λ (set1 set2) ...) <-)) difference ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... set!->var (set!->exp (-> (λ (exp) ...) <-)) closure? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... set!->var (set!->exp (-> (λ (exp) ...) <-)) closure? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... set!? (set!->var (-> (λ (exp) ...) <-)) set!->exp ...) ...)
  (env ()))
clos/con:
	'((letrec* (... set!? (set!->var (-> (λ (exp) ...) <-)) set!->exp ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... string->list (apply (-> (λ (f l) ...) <-)) assv ...) ...)
  (env ()))
clos/con:
	'((letrec* (... string->list (apply (-> (λ (f l) ...) <-)) assv ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... symbol<? (insert (-> (λ (sym S) ...) <-)) remove ...) ...)
  (env ()))
clos/con:
	'((letrec* (... symbol<? (insert (-> (λ (sym S) ...) <-)) remove ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (letrec* (... union (difference (-> (λ (set1 set2) ...) <-)) reduce ...) ...)
  (env ()))
clos/con:
	'((letrec* (... union (difference (-> (λ (set1 set2) ...) <-)) reduce ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query:
  (lettypes cons ... error (letrec* (car ... the-benchmark-program) ...))
  (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (emit input-program) (-> (letrec* (compiled-program) ...) <-))
  (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥)

'(query:
  (λ (exp) (-> (app or (app integer? exp) (app boolean? exp)) <-))
  (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: ((top) lettypes (cons ... error) ...) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> analyze-mutable-variables <-) input-program) (env ()))
clos/con:
	'((letrec*
   (...
    is-mutable?
    (analyze-mutable-variables (-> (λ (exp) ...) <-))
    wrap-mutables
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> boolean? <-) exp) (env ()))
clos/con:
	'((prim boolean?) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> c-compile-and-emit <-) emit the-benchmark-program) (env ()))
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

'(query: (app (-> const? <-) exp) (env ()))
clos/con:
	'((letrec* (... assq-remove-keys (const? (-> (λ (exp) ...) <-)) ref? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> desugar <-) input-program) (env ()))
clos/con:
	'((letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> integer? <-) exp) (env ()))
clos/con:
	'((prim integer?) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> nil <-)) (env ()))
clos/con:
	'((app (-> nil <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app (-> or <-) (app integer? exp) (app boolean? exp)) (env ()))
clos/con:
	'((prim or) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app analyze-mutable-variables (-> input-program <-)) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app boolean? (-> exp <-)) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app c-compile-and-emit (-> emit <-) the-benchmark-program) (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-env-struct
    (emit (-> (λ (line) ...) <-))
    c-compile-and-emit
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app c-compile-and-emit emit (-> the-benchmark-program <-)) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app const? (-> exp <-)) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app desugar (-> input-program <-)) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app integer? (-> exp <-)) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (app or (-> (app integer? exp) <-) (app boolean? exp)) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app or (app integer? exp) (-> (app boolean? exp) <-)) (env ()))
clos/con:
	'((con #f) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (app set! input-program (-> (app desugar input-program) <-)) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (let (_) (-> (let (_) ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (letrec* (... () (compiled-program (-> "" <-)) () ...) ...) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ "")

'(query: (letrec* (compiled-program) (-> (let (_) ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥)

'(query: (match (-> (app const? exp) <-) (#f) _) (env ()))
clos/con:
	'((con #t) (env ()))
literals: '(⊥ ⊥ ⊥)

'(query: (match (app const? exp) (#f) (_ (-> exp <-))) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(query: (λ (exp) (-> (match (app const? exp) ...) <-)) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(store:
  _
  (letrec*
   (...
    emit
    (c-compile-and-emit (-> (λ (emit input-program) ...) <-))
    the-benchmark-program
    ...)
   ...)
  (env ()))
clos/con:
	'(((top) app void) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  analyze-mutable-variables
  ((top) lettypes (cons ... error) ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    is-mutable?
    (analyze-mutable-variables (-> (λ (exp) ...) <-))
    wrap-mutables
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  analyze-mutable-variables
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
    is-mutable?
    (analyze-mutable-variables (-> (λ (exp) ...) <-))
    wrap-mutables
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  app?
  (letrec*
   (...
    is-mutable?
    (analyze-mutable-variables (-> (λ (exp) ...) <-))
    wrap-mutables
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec* (... if->else (app? (-> (λ (exp) ...) <-)) app->fun ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  app?
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec* (... if->else (app? (-> (λ (exp) ...) <-)) app->fun ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  append
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... for-each (append (-> (λ (lst1 lst2) ...) <-)) string->list ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  azip
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... reduce (azip (-> (λ (list1 list2) ...) <-)) assq-remove-key ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  begin=>let
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... letrec=>lets+sets (begin=>let (-> (λ (exp) ...) <-)) desugar ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  begin?
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec* (... prim? (begin? (-> (λ (exp) ...) <-)) begin->exps ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  boolean?
  (letrec* (... assq-remove-keys (const? (-> (λ (exp) ...) <-)) ref? ...) ...)
  (env ()))
clos/con:
	'((λ (exp) (-> (app or (app integer? exp) (app boolean? exp)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-compile-env-struct
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
   (... c-compile-lambda (c-compile-env-struct (-> (λ (env) ...) <-)) emit ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  c-compile-program
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
    closure-convert
    (c-compile-program (-> (λ (exp) ...) <-))
    c-compile-exp
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadr
  (letrec*
   (...
    emit
    (c-compile-and-emit (-> (λ (emit input-program) ...) <-))
    the-benchmark-program
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
	'((letrec* (... null? (cadr (-> (λ (p) ...) <-)) cddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cadr
  (letrec*
   (...
    is-mutable?
    (analyze-mutable-variables (-> (λ (exp) ...) <-))
    wrap-mutables
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
	'((letrec* (... null? (cadr (-> (λ (p) ...) <-)) cddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  car
  (letrec*
   (...
    emit
    (c-compile-and-emit (-> (λ (emit input-program) ...) <-))
    the-benchmark-program
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cell->value
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cell? (cell->value (-> (λ (exp) ...) <-)) cell-get? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cell-get->cell
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... cell-get? (cell-get->cell (-> (λ (exp) ...) <-)) substitute-var ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cell-get?
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... cell->value (cell-get? (-> (λ (exp) ...) <-)) cell-get->cell ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  cell?
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... set-cell!->value (cell? (-> (λ (exp) ...) <-)) cell->value ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  closure->env
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... closure->lam (closure->env (-> (λ (exp) ...) <-)) env-make? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  closure->lam
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... closure? (closure->lam (-> (λ (exp) ...) <-)) closure->env ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  closure-convert
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
    get-environment
    (closure-convert (-> (λ (exp) ...) <-))
    c-compile-program
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  closure?
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... set!->exp (closure? (-> (λ (exp) ...) <-)) closure->lam ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  compiled-program
  (letrec*
   (...
    emit
    (c-compile-and-emit (-> (λ (emit input-program) ...) <-))
    the-benchmark-program
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ "")

'(store:
  cons
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((λ (exp) (-> (match (app const? exp) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  const?
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec* (... assq-remove-keys (const? (-> (λ (exp) ...) <-)) ref? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  desugar
  (letrec*
   (...
    emit
    (c-compile-and-emit (-> (λ (emit input-program) ...) <-))
    the-benchmark-program
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  desugar
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  emit
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
    c-compile-env-struct
    (emit (-> (λ (line) ...) <-))
    c-compile-and-emit
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  env-get->env
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... env-get->field (env-get->env (-> (λ (exp) ...) <-)) set-cell!? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  env-get->field
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... env-get->id (env-get->field (-> (λ (exp) ...) <-)) env-get->env ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  env-get->id
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... env-get? (env-get->id (-> (λ (exp) ...) <-)) env-get->field ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  env-get?
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... env-make->values (env-get? (-> (λ (exp) ...) <-)) env-get->id ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  env-make->fields
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    env-make->id
    (env-make->fields (-> (λ (exp) ...) <-))
    env-make->values
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  env-make->id
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... env-make? (env-make->id (-> (λ (exp) ...) <-)) env-make->fields ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  env-make->values
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... env-make->fields (env-make->values (-> (λ (exp) ...) <-)) env-get? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  env-make?
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... closure->env (env-make? (-> (λ (exp) ...) <-)) env-make->id ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  environments
  (letrec*
   (...
    emit
    (c-compile-and-emit (-> (λ (emit input-program) ...) <-))
    the-benchmark-program
    ...)
   ...)
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  error
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((λ (exp) (-> (match (app const? exp) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  exp
  (letrec*
   (...
    is-mutable?
    (analyze-mutable-variables (-> (λ (exp) ...) <-))
    wrap-mutables
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(store:
  exp
  (letrec* (... assq-remove-keys (const? (-> (λ (exp) ...) <-)) ref? ...) ...)
  (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(store:
  exp
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(store:
  for-each
  (letrec*
   (...
    emit
    (c-compile-and-emit (-> (λ (emit input-program) ...) <-))
    the-benchmark-program
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec* (... map (for-each (-> (λ (f lst) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  if->condition
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec* (... if? (if->condition (-> (λ (exp) ...) <-)) if->then ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  if->else
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec* (... if->then (if->else (-> (λ (exp) ...) <-)) app? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  if->then
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... if->condition (if->then (-> (λ (exp) ...) <-)) if->else ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  if?
  (letrec*
   (...
    is-mutable?
    (analyze-mutable-variables (-> (λ (exp) ...) <-))
    wrap-mutables
    ...)
   ...)
  (env ()))
clos/con:
	'((letrec* (... lambda->exp (if? (-> (λ (exp) ...) <-)) if->condition ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  if?
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec* (... lambda->exp (if? (-> (λ (exp) ...) <-)) if->condition ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  input-program
  (app set! (-> input-program <-) (app desugar input-program))
  (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(store:
  input-program
  (letrec*
   (...
    emit
    (c-compile-and-emit (-> (λ (emit input-program) ...) <-))
    the-benchmark-program
    ...)
   ...)
  (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(store:
  integer?
  (letrec* (... assq-remove-keys (const? (-> (λ (exp) ...) <-)) ref? ...) ...)
  (env ()))
clos/con:
	'((λ (exp) (-> (app or (app integer? exp) (app boolean? exp)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  lambda->exp
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... lambda->formals (lambda->exp (-> (λ (exp) ...) <-)) if? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  lambda->formals
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... lambda? (lambda->formals (-> (λ (exp) ...) <-)) lambda->exp ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  lambda?
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... letrec->args (lambda? (-> (λ (exp) ...) <-)) lambda->formals ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  lambdas
  (letrec*
   (...
    emit
    (c-compile-and-emit (-> (λ (emit input-program) ...) <-))
    the-benchmark-program
    ...)
   ...)
  (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  let=>lambda
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... substitute (let=>lambda (-> (λ (exp) ...) <-)) letrec=>lets+sets ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  let?
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec* (... ref? (let? (-> (λ (exp) ...) <-)) let->bindings ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  letrec=>lets+sets
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... let=>lambda (letrec=>lets+sets (-> (λ (exp) ...) <-)) begin=>let ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  letrec?
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... let->args (letrec? (-> (λ (exp) ...) <-)) letrec->bindings ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  map
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec* (... cadddr (map (-> (λ (f lst) ...) <-)) for-each ...) ...)
  (env ()))
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  nil
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((λ (exp) (-> (match (app const? exp) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  number->string
  (letrec*
   (...
    emit
    (c-compile-and-emit (-> (λ (emit input-program) ...) <-))
    the-benchmark-program
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (emit input-program) (-> (letrec* (compiled-program) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  or
  (letrec* (... assq-remove-keys (const? (-> (λ (exp) ...) <-)) ref? ...) ...)
  (env ()))
clos/con:
	'((λ (exp) (-> (app or (app integer? exp) (app boolean? exp)) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  prim?
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec* (... app->args (prim? (-> (λ (exp) ...) <-)) begin? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  ref?
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec* (... const? (ref? (-> (λ (exp) ...) <-)) let? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  set!->exp
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec* (... set!->var (set!->exp (-> (λ (exp) ...) <-)) closure? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  set!->var
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec* (... set!? (set!->var (-> (λ (exp) ...) <-)) set!->exp ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  set!?
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec* (... begin->exps (set!? (-> (λ (exp) ...) <-)) set!->var ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  set-cell!->cell
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (...
    set-cell!?
    (set-cell!->cell (-> (λ (exp) ...) <-))
    set-cell!->value
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  set-cell!->value
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... set-cell!->cell (set-cell!->value (-> (λ (exp) ...) <-)) cell? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  set-cell!?
  (letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
clos/con:
	'((letrec*
   (... env-get->env (set-cell!? (-> (λ (exp) ...) <-)) set-cell!->cell ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  string-append
  (letrec*
   (...
    emit
    (c-compile-and-emit (-> (λ (emit input-program) ...) <-))
    the-benchmark-program
    ...)
   ...)
  (env ()))
clos/con:
	'((λ (emit input-program) (-> (letrec* (compiled-program) ...) <-)) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  void
  (letrec* (... assq (void (-> (λ () ...) <-)) tagged-list? ...) ...)
  (env ()))
clos/con:
	'((letrec* (... assq (void (-> (λ () ...) <-)) tagged-list? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store:
  wrap-mutables
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
    analyze-mutable-variables
    (wrap-mutables (-> (λ (exp) ...) <-))
    mangle
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: allocate-environment ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    environments
    (allocate-environment (-> (λ (fields) ...) <-))
    get-environment
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: allocate-lambda ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... lambdas (allocate-lambda (-> (λ (lam) ...) <-)) get-lambda ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: app->args ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... app->fun (app->args (-> (λ (exp) ...) <-)) prim? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: app->fun ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... app? (app->fun (-> (λ (exp) ...) <-)) app->args ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: app? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... if->else (app? (-> (λ (exp) ...) <-)) app->fun ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: append ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... for-each (append (-> (λ (lst1 lst2) ...) <-)) string->list ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: apply ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... string->list (apply (-> (λ (f l) ...) <-)) assv ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: assq ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... assv (assq (-> (λ (x f) ...) <-)) void ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: assq-remove-key ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... azip (assq-remove-key (-> (λ (env key) ...) <-)) assq-remove-keys ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: assq-remove-keys ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    assq-remove-key
    (assq-remove-keys (-> (λ (env keys) ...) <-))
    const?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: assv ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... apply (assv (-> (λ (x f) ...) <-)) assq ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: azip ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... reduce (azip (-> (λ (list1 list2) ...) <-)) assq-remove-key ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: begin->exps ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... begin? (begin->exps (-> (λ (exp) ...) <-)) set!? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: begin=>let ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... letrec=>lets+sets (begin=>let (-> (λ (exp) ...) <-)) desugar ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: begin? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... prim? (begin? (-> (λ (exp) ...) <-)) begin->exps ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: c-compile-and-emit ((top) lettypes (cons ... error) ...) (env ()))
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

'(store: c-compile-app ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-args
    (c-compile-app (-> (λ (exp append-preamble) ...) <-))
    c-compile-if
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: c-compile-args ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-ref
    (c-compile-args (-> (λ (args append-preamble) ...) <-))
    c-compile-app
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: c-compile-cell ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-cell-get
    (c-compile-cell (-> (λ (exp append-preamble) ...) <-))
    c-compile-env-make
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: c-compile-cell-get ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-set-cell!
    (c-compile-cell-get (-> (λ (exp append-preamble) ...) <-))
    c-compile-cell
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: c-compile-closure ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    get-lambda
    (c-compile-closure (-> (λ (exp append-preamble) ...) <-))
    c-compile-formals
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: c-compile-const ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-exp
    (c-compile-const (-> (λ (exp) ...) <-))
    c-compile-prim
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: c-compile-env-get ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-env-make
    (c-compile-env-get (-> (λ (exp append-preamble) ...) <-))
    num-lambdas
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: c-compile-env-make ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-cell
    (c-compile-env-make (-> (λ (exp append-preamble) ...) <-))
    c-compile-env-get
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: c-compile-env-struct ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... c-compile-lambda (c-compile-env-struct (-> (λ (env) ...) <-)) emit ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: c-compile-exp ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-program
    (c-compile-exp (-> (λ (exp append-preamble) ...) <-))
    c-compile-const
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: c-compile-formals ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-closure
    (c-compile-formals (-> (λ (formals) ...) <-))
    c-compile-lambda
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: c-compile-if ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-app
    (c-compile-if (-> (λ (exp append-preamble) ...) <-))
    c-compile-set-cell!
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: c-compile-lambda ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-formals
    (c-compile-lambda (-> (λ (exp) ...) <-))
    c-compile-env-struct
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: c-compile-prim ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... c-compile-const (c-compile-prim (-> (λ (p) ...) <-)) c-compile-ref ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: c-compile-program ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    closure-convert
    (c-compile-program (-> (λ (exp) ...) <-))
    c-compile-exp
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: c-compile-ref ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-prim
    (c-compile-ref (-> (λ (exp) ...) <-))
    c-compile-args
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: c-compile-set-cell! ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-if
    (c-compile-set-cell! (-> (λ (exp append-preamble) ...) <-))
    c-compile-cell-get
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: caadr ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... cddr (caadr (-> (λ (p) ...) <-)) caddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: cadddr ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... caddr (cadddr (-> (λ (p) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: caddr ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... caadr (caddr (-> (λ (p) ...) <-)) cadddr ...) ...) (env ()))
	'((letrec* (... cadr (caddr (-> (λ (cadr-v) ...) <-)) map ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: cadr ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... cdr (cadr (-> (λ (cadr-v) ...) <-)) caddr ...) ...) (env ()))
	'((letrec* (... null? (cadr (-> (λ (p) ...) <-)) cddr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: car ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... () (car (-> (λ (car-v) ...) <-)) cdr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: cddr ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... cadr (cddr (-> (λ (p) ...) <-)) caadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: cdr ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... car (cdr (-> (λ (cdr-v) ...) <-)) cadr ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: cell->value ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... cell? (cell->value (-> (λ (exp) ...) <-)) cell-get? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: cell-get->cell ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... cell-get? (cell-get->cell (-> (λ (exp) ...) <-)) substitute-var ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: cell-get? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... cell->value (cell-get? (-> (λ (exp) ...) <-)) cell-get->cell ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: cell? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... set-cell!->value (cell? (-> (λ (exp) ...) <-)) cell->value ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: char->natural ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    tagged-list?
    (char->natural (-> (λ (c) ...) <-))
    integer->char-list
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: closure->env ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... closure->lam (closure->env (-> (λ (exp) ...) <-)) env-make? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: closure->lam ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... closure? (closure->lam (-> (λ (exp) ...) <-)) closure->env ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: closure-convert ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    get-environment
    (closure-convert (-> (λ (exp) ...) <-))
    c-compile-program
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: closure? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... set!->exp (closure? (-> (λ (exp) ...) <-)) closure->lam ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: const? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... assq-remove-keys (const? (-> (λ (exp) ...) <-)) ref? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: desugar ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... begin=>let (desugar (-> (λ (exp) ...) <-)) free-vars ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: difference ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... union (difference (-> (λ (set1 set2) ...) <-)) reduce ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: emit ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    c-compile-env-struct
    (emit (-> (λ (line) ...) <-))
    c-compile-and-emit
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: env-get->env ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... env-get->field (env-get->env (-> (λ (exp) ...) <-)) set-cell!? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: env-get->field ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... env-get->id (env-get->field (-> (λ (exp) ...) <-)) env-get->env ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: env-get->id ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... env-get? (env-get->id (-> (λ (exp) ...) <-)) env-get->field ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: env-get? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... env-make->values (env-get? (-> (λ (exp) ...) <-)) env-get->id ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: env-make->fields ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    env-make->id
    (env-make->fields (-> (λ (exp) ...) <-))
    env-make->values
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: env-make->id ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... env-make? (env-make->id (-> (λ (exp) ...) <-)) env-make->fields ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: env-make->values ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... env-make->fields (env-make->values (-> (λ (exp) ...) <-)) env-get? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: env-make? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... closure->env (env-make? (-> (λ (exp) ...) <-)) env-make->id ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: environments ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: for-each ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... map (for-each (-> (λ (f lst) ...) <-)) append ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: free-vars ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... desugar (free-vars (-> (λ (exp) ...) <-)) mutable-variables ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: gensym ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... gensym-count (gensym (-> (λ (name) ...) <-)) member ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: gensym-count ((top) lettypes (cons ... error) ...) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(store: get-environment ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    allocate-environment
    (get-environment (-> (λ (id) ...) <-))
    closure-convert
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: get-lambda ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    allocate-lambda
    (get-lambda (-> (λ (id) ...) <-))
    c-compile-closure
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: if->condition ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... if? (if->condition (-> (λ (exp) ...) <-)) if->then ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: if->else ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... if->then (if->else (-> (λ (exp) ...) <-)) app? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: if->then ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... if->condition (if->then (-> (λ (exp) ...) <-)) if->else ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: if? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... lambda->exp (if? (-> (λ (exp) ...) <-)) if->condition ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: insert ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... symbol<? (insert (-> (λ (sym S) ...) <-)) remove ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: integer->char-list ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    char->natural
    (integer->char-list (-> (λ (n) ...) <-))
    gensym-count
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: is-mutable? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    mark-mutable
    (is-mutable? (-> (λ (symbol) ...) <-))
    analyze-mutable-variables
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: lambda->exp ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... lambda->formals (lambda->exp (-> (λ (exp) ...) <-)) if? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: lambda->formals ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... lambda? (lambda->formals (-> (λ (exp) ...) <-)) lambda->exp ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: lambda? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... letrec->args (lambda? (-> (λ (exp) ...) <-)) lambda->formals ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: lambdas ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: let->args ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... let->bound-vars (let->args (-> (λ (exp) ...) <-)) letrec? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: let->bindings ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... let? (let->bindings (-> (λ (exp) ...) <-)) let->exp ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: let->bound-vars ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... let->exp (let->bound-vars (-> (λ (exp) ...) <-)) let->args ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: let->exp ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... let->bindings (let->exp (-> (λ (exp) ...) <-)) let->bound-vars ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: let=>lambda ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... substitute (let=>lambda (-> (λ (exp) ...) <-)) letrec=>lets+sets ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: let? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... ref? (let? (-> (λ (exp) ...) <-)) let->bindings ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: letrec->args ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... letrec->bound-vars (letrec->args (-> (λ (exp) ...) <-)) lambda? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: letrec->bindings ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... letrec? (letrec->bindings (-> (λ (exp) ...) <-)) letrec->exp ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: letrec->bound-vars ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    letrec->exp
    (letrec->bound-vars (-> (λ (exp) ...) <-))
    letrec->args
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: letrec->exp ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    letrec->bindings
    (letrec->exp (-> (λ (exp) ...) <-))
    letrec->bound-vars
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: letrec=>lets+sets ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... let=>lambda (letrec=>lets+sets (-> (λ (exp) ...) <-)) begin=>let ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: letrec? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... let->args (letrec? (-> (λ (exp) ...) <-)) letrec->bindings ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: mangle ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... wrap-mutables (mangle (-> (λ (symbol) ...) <-)) num-environments ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: map ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... cadddr (map (-> (λ (f lst) ...) <-)) for-each ...) ...)
  (env ()))
	'((letrec* (... caddr (map (-> (λ (map-f map-l) ...) <-)) pair? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: mark-mutable ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    mutable-variables
    (mark-mutable (-> (λ (symbol) ...) <-))
    is-mutable?
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: member ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... gensym (member (-> (λ (sym S) ...) <-)) symbol<? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: mutable-variables ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((con nil) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: null? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... pair? (null? (-> (λ (null?-v) ...) <-)) cadr ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: num-environments ((top) lettypes (cons ... error) ...) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(store: num-lambdas ((top) lettypes (cons ... error) ...) (env ()))
clos/con: ⊥
literals: '(0 ⊥ ⊥)

'(store: pair? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... map (pair? (-> (λ (pair?-v) ...) <-)) null? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: prim? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... app->args (prim? (-> (λ (exp) ...) <-)) begin? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: reduce ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... difference (reduce (-> (λ (f lst init) ...) <-)) azip ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: ref? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... const? (ref? (-> (λ (exp) ...) <-)) let? ...) ...) (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: remove ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... insert (remove (-> (λ (sym S) ...) <-)) union ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: set!->exp ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... set!->var (set!->exp (-> (λ (exp) ...) <-)) closure? ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: set!->var ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... set!? (set!->var (-> (λ (exp) ...) <-)) set!->exp ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: set!? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... begin->exps (set!? (-> (λ (exp) ...) <-)) set!->var ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: set-cell!->cell ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    set-cell!?
    (set-cell!->cell (-> (λ (exp) ...) <-))
    set-cell!->value
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: set-cell!->value ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... set-cell!->cell (set-cell!->value (-> (λ (exp) ...) <-)) cell? ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: set-cell!? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... env-get->env (set-cell!? (-> (λ (exp) ...) <-)) set-cell!->cell ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: string->list ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... append (string->list (-> (λ (s) ...) <-)) apply ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: substitute ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... substitute-var (substitute (-> (λ (env exp) ...) <-)) let=>lambda ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: substitute-var ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    cell-get->cell
    (substitute-var (-> (λ (env var) ...) <-))
    substitute
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: symbol<? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... member (symbol<? (-> (λ (sym1 sym2) ...) <-)) insert ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: tagged-list? ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (... void (tagged-list? (-> (λ (tag l) ...) <-)) char->natural ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: the-benchmark-program ((top) lettypes (cons ... error) ...) (env ()))
clos/con: ⊥
literals: '(3 ⊥ ⊥)

'(store: union ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec* (... remove (union (-> (λ (set1 set2) ...) <-)) difference ...) ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)

'(store: void (λ (exp) (-> (match (app const? exp) ...) <-)) (env ()))
clos/con: ⊥
literals: '(⊥ ⊥ ⊥)

'(store: wrap-mutables ((top) lettypes (cons ... error) ...) (env ()))
clos/con:
	'((letrec*
   (...
    analyze-mutable-variables
    (wrap-mutables (-> (λ (exp) ...) <-))
    mangle
    ...)
   ...)
  (env ()))
literals: '(⊥ ⊥ ⊥)
