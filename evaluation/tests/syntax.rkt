'structural-rec
'(app (λ (x) (app x x)) (λ (y) (app y y)))
'prim-match
'(letrec*
  ((try (λ (f) (app or (app f (app #t))))))
  (app try (λ (f) (app not f))))
'multi-param
'(app (λ (x y) (app x y)) (λ (z) z) 2)
'let
'(let ((x (λ (y) y))) x)
'let-num
'(let ((x (λ (y) y))) (app x 1))
'id
'(app (λ (x) x) (λ (y) y))
'err
'(app (λ (x) (app x x)) 2)
'constr
'(lettypes
  ((cons car cdr) (nil))
  (let ((x (app cons 1 (app nil)))) (match x ((cons 1 n) n) ((_) x))))
'inst
'(letrec*
  ((apply (λ (f) (λ (x) (app f x))))
   (add1 (λ (x) (app + 1 x)))
   (sub1 (λ (x) (app - 1 x))))
  (let ((_ (app (app apply add1) 42))) (app (app apply sub1) 35)))
'basic-letstar
'(let* ((a 10) (b a)) a)
'basic-letrec
'(letrec ((a
           (λ (y) (match (app equal? y 0) ((#f) (app a (app - y 1))) (_ y)))))
   (app a 2))
'app-num
'(let ((x (λ (y) y))) (let ((_ (app x 1))) (app x 2)))
'sat-small
'(letrec*
  ((phi (λ (x1 x2) (app or x1 (app not x2))))
   (try (λ (f) (app or (app f (app #t)) (app f (app #f)))))
   (sat-solve-2 (λ (p) (app try (λ (n1) (app try (λ (n2) (app p n1 n2))))))))
  (app sat-solve-2 phi))
'ack
'(letrec*
  ((ack
    (λ (m n)
      (match
       (app = m 0)
       ((#f)
        (match
         (app = n 0)
         ((#f) (app ack (app - m 1) (app ack m (app - n 1))))
         (_ (app ack (app - m 1) 1))))
       (_ (app + n 1))))))
  (app ack 3 12))
'blur
'(letrec ((id (λ (x) x))
          (blur (λ (y) y))
          (lp
           (λ (a n)
             (match
              (app <= n 1)
              ((#f)
               (let* ((r (app (app blur id) (app #t)))
                      (s (app (app blur id) (app #f))))
                 (app not (app (app blur lp) s (app - n 1)))))
              (_ (app id a))))))
   (app lp (app #f) 2))
'cpstak
'(letrec*
  ((cpstak
    (λ (x y z)
      (letrec*
       ((tak
         (λ (x y z k)
           (match
            (app not (app < y x))
            ((#f)
             (app
              tak
              (app - x 1)
              y
              z
              (λ (v1)
                (app
                 tak
                 (app - y 1)
                 z
                 x
                 (λ (v2)
                   (app tak (app - z 1) x y (λ (v3) (app tak v1 v2 v3 k))))))))
            (_ (app k z))))))
       (app tak x y z (λ (a) a))))))
  (app cpstak 32 15 8))
'deriv
'(lettypes
  ((cons car cdr) (nil))
  (letrec*
   ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
    (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
    (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
    (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
    (map
     (λ (map-f map-l)
       (match
        map-l
        ((cons map-c map-d) (app cons (app map-f map-c) (app map map-f map-d)))
        ((nil) (app nil)))))
    (pair?
     (λ (pair?-v)
       (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
    (deriv
     (λ (a)
       (match
        (app not (app pair? a))
        ((#f)
         (match
          (app eq? (app car a) '+)
          ((#f)
           (match
            (app eq? (app car a) '-)
            ((#f)
             (match
              (app eq? (app car a) '*)
              ((#f)
               (match
                (app eq? (app car a) '/)
                ((#f) (app error (app #f) "No derivation method available"))
                (_
                 (app
                  cons
                  '-
                  (app
                   cons
                   (app
                    cons
                    '/
                    (app
                     cons
                     (app deriv (app cadr a))
                     (app cons (app caddr a) (app nil))))
                   (app
                    cons
                    (app
                     cons
                     '/
                     (app
                      cons
                      (app cadr a)
                      (app
                       cons
                       (app
                        cons
                        '*
                        (app
                         cons
                         (app caddr a)
                         (app
                          cons
                          (app caddr a)
                          (app cons (app deriv (app caddr a)) (app nil)))))
                       (app nil))))
                    (app nil)))))))
              (_
               (app
                cons
                '*
                (app
                 cons
                 a
                 (app
                  cons
                  (app
                   cons
                   '+
                   (app
                    map
                    (λ (a)
                      (app
                       cons
                       '/
                       (app cons (app deriv a) (app cons a (app nil)))))
                    (app cdr a)))
                  (app nil)))))))
            (_ (app cons '- (app map deriv (app cdr a))))))
          (_ (app cons '+ (app map deriv (app cdr a))))))
        (_ (match (app eq? a 'x) ((#f) 0) (_ 1)))))))
   (app
    deriv
    (app
     cons
     '+
     (app
      cons
      (app cons '* (app cons 3 (app cons 'x (app cons 'x (app nil)))))
      (app
       cons
       (app cons '* (app cons 'a (app cons 'x (app cons 'x (app nil)))))
       (app
        cons
        (app cons '* (app cons 'b (app cons 'x (app nil))))
        (app cons 5 (app nil)))))))))
'eta
'(letrec*
  ((do-something (λ () 10)) (id (λ (y) (let ((_ (app do-something))) y))))
  (let ((_ (app (app id (λ (a) a)) (app #t))))
    (app (app id (λ (b) b)) (app #f))))
'facehugger
'(letrec*
  ((id (λ (x) x))
   (f (λ (n) (match (app <= n 1) ((#f) (app * n (app f (app - n 1)))) (_ 1))))
   (g (λ (n) (match (app <= n 1) ((#f) (app * n (app g (app - n 1)))) (_ 1)))))
  (app + (app (app id f) 3) (app (app id g) 4)))
'flatten
'(lettypes
  ((cons car cdr) (nil))
  (letrec*
   ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
    (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
    (pair?
     (λ (pair?-v)
       (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
    (null? (λ (null?-v) (match null?-v ((nil) (app #t)) (_ (app #f)))))
    (append
     (λ (x y)
       (match
        (app null? x)
        ((#f) (app cons (app car x) (app append (app cdr x) y)))
        (_ y))))
    (flatten
     (λ (x)
       (match
        (app pair? x)
        ((#f) (match (app null? x) ((#f) (app cons x (app nil))) (_ x)))
        (_
         (app append (app flatten (app car x)) (app flatten (app cdr x))))))))
   (app
    flatten
    (app
     cons
     (app cons 1 (app cons 2 (app nil)))
     (app
      cons
      (app
       cons
       (app cons (app cons 3 (app cons 4 (app cons 5 (app nil)))) (app nil))
       (app nil))
      (app nil))))))
'kcfa-2
'(app
  (λ (f1) (let ((_ (app f1 (app #t)))) (app f1 (app #f))))
  (λ (x1)
    (app
     (λ (f2) (let ((_ (app f2 (app #t)))) (app f2 (app #f))))
     (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))))
'kcfa-3
'(app
  (λ (f1) (let ((_ (app f1 (app #t)))) (app f1 (app #f))))
  (λ (x1)
    (app
     (λ (f2) (let ((_ (app f2 (app #t)))) (app f2 (app #f))))
     (λ (x2)
       (app
        (λ (f3) (let ((_ (app f3 (app #t)))) (app f3 (app #f))))
        (λ (x3) (app (λ (z) (app z x1 x2 x3)) (λ (y1 y2 y3) y1))))))))
'loop2-1
'(letrec ((lp1
           (λ (i x)
             (match
              (app = 0 i)
              ((#f)
               (letrec ((lp2
                         (λ (j f y)
                           (match
                            (app = 0 j)
                            ((#f) (app lp2 (app - j 1) f (app f y)))
                            (_ (app lp1 (app - i 1) y))))))
                 (app lp2 10 (λ (n) (app + n i)) x)))
              (_ x)))))
   (app lp1 10 0))
'map
'(lettypes
  ((cons car cdr) (nil))
  (letrec*
   ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
    (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
    (pair?
     (λ (pair?-v)
       (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
    (debug-trace (λ () (app #f)))
    (id (λ (xx) (let ((_ (app debug-trace))) xx)))
    (my-map
     (λ (f l)
       (let ((_ (app debug-trace)))
         (letrec ((lp
                   (λ (lst)
                     (match
                      (app not (app pair? lst))
                      ((#f)
                       (app
                        cons
                        (app (app id f) (app car lst))
                        (app lp (app cdr lst))))
                      (_ (app nil))))))
           (app lp l))))))
   (let ((_
          (app
           my-map
           (app id (λ (a) (app + 1 a)))
           (app cons 1 (app cons 2 (app cons 3 (app nil)))))))
     (app
      my-map
      (app id (λ (b) (app + 1 b)))
      (app cons 7 (app cons 8 (app cons 9 (app nil))))))))
'mj09
'(let ((h
        (λ (b)
          (let ((g (λ (z) z)))
            (let ((f (λ (k) (match b ((#f) (app k 2)) (_ (app k 1))))))
              (let ((y (app f (λ (x) x)))) (app g y)))))))
   (let ((x (app h (app #t))) (y (app h (app #f)))) y))
'primtest
'(letrec*
  ((square (λ (x) (app * x x)))
   (modulo-power
    (λ (base exp n)
      (match
       (app = exp 0)
       ((#f)
        (match
         (app odd? exp)
         ((#f)
          (app modulo (app square (app modulo-power base (app / exp 2) n)) n))
         (_
          (app
           modulo
           (app * base (app modulo-power base (app - exp 1) n))
           n))))
       (_ 1))))
   (is-trivial-composite?
    (λ (n)
      (app
       or
       (app = (app modulo n 2) 0)
       (app = (app modulo n 3) 0)
       (app = (app modulo n 5) 0)
       (app = (app modulo n 7) 0)
       (app = (app modulo n 11) 0)
       (app = (app modulo n 13) 0)
       (app = (app modulo n 17) 0)
       (app = (app modulo n 19) 0)
       (app = (app modulo n 23) 0))))
   (is-fermat-prime?
    (λ (n iterations)
      (app
       or
       (app <= iterations 0)
       (let* ((byte-size (app ceiling (app / (app log n) (app log 2))))
              (a (app random byte-size)))
         (match
          (app = (app modulo-power a (app - n 1) n) 1)
          ((#f) (app #f))
          (_ (app is-fermat-prime? n (app - iterations 1))))))))
   (generate-fermat-prime
    (λ (byte-size iterations)
      (let ((n (app random byte-size)))
        (match
         (app
          and
          (app not (app is-trivial-composite? n))
          (app is-fermat-prime? n iterations))
         ((#f) (app generate-fermat-prime byte-size iterations))
         (_ n)))))
   (iterations 10)
   (byte-size 15))
  (app generate-fermat-prime byte-size iterations))
'regex
'(lettypes
  ((cons car cdr) (nil))
  (letrec*
   ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
    (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
    (cadr (λ (cadr-v) (app car (app cdr cadr-v))))
    (caddr (λ (cadr-v) (app car (app cdr (app cdr cadr-v)))))
    (pair?
     (λ (pair?-v)
       (match pair?-v ((cons pair?-c pair?-d) (app #t)) (_ (app #f)))))
    (null? (λ (null?-v) (match null?-v ((nil) (app #t)) (_ (app #f)))))
    (debug-trace (λ () 'do-nothing))
    (cadr (λ (p) (app car (app cdr p))))
    (caddr (λ (p) (app car (app cdr (app cdr p)))))
    (regex-NULL (app #f))
    (regex-BLANK (app #t))
    (regex-alt? (λ (re) (app and (app pair? re) (app eq? (app car re) 'alt))))
    (regex-seq? (λ (re) (app and (app pair? re) (app eq? (app car re) 'seq))))
    (regex-rep? (λ (re) (app and (app pair? re) (app eq? (app car re) 'rep))))
    (regex-null? (λ (re) (app eq? re (app #f))))
    (regex-empty? (λ (re) (app eq? re (app #t))))
    (regex-atom? (λ (re) (app or (app char? re) (app symbol? re))))
    (match-seq
     (λ (re f)
       (app and (app regex-seq? re) (app f (app cadr re) (app caddr re)))))
    (match-alt
     (λ (re f)
       (app and (app regex-alt? re) (app f (app cadr re) (app caddr re)))))
    (match-rep (λ (re f) (app and (app regex-rep? re) (app f (app cadr re)))))
    (seq
     (λ (pat1 pat2)
       (match
        (app regex-null? pat1)
        ((#f)
         (match
          (app regex-null? pat2)
          ((#f)
           (match
            (app regex-empty? pat1)
            ((#f)
             (match
              (app regex-empty? pat2)
              ((#f) (app cons 'seq (app cons pat1 (app cons pat2 (app nil)))))
              (_ pat1)))
            (_ pat2)))
          (_ regex-NULL)))
        (_ regex-NULL))))
    (alt
     (λ (pat1 pat2)
       (match
        (app regex-null? pat1)
        ((#f)
         (match
          (app regex-null? pat2)
          ((#f) (app cons 'alt (app cons pat1 (app cons pat2 (app nil)))))
          (_ pat1)))
        (_ pat2))))
    (rep
     (λ (pat)
       (match
        (app regex-null? pat)
        ((#f)
         (match
          (app regex-empty? pat)
          ((#f) (app cons 'rep (app cons pat (app nil))))
          (_ regex-BLANK)))
        (_ regex-BLANK))))
    (regex-empty
     (λ (re)
       (match
        (app regex-empty? re)
        ((#f)
         (match
          (app regex-null? re)
          ((#f)
           (match
            (app regex-atom? re)
            ((#f)
             (match
              (app
               match-seq
               re
               (λ (pat1 pat2)
                 (app seq (app regex-empty pat1) (app regex-empty pat2))))
              ((#f)
               (match
                (app
                 match-alt
                 re
                 (λ (pat1 pat2)
                   (app alt (app regex-empty pat1) (app regex-empty pat2))))
                ((#f) (match (app regex-rep? re) ((#f) (app #f)) (_ (app #t))))
                (c-x c-x)))
              (c-x c-x)))
            (_ (app #f))))
          (_ (app #f))))
        (_ (app #t)))))
    (regex-derivative
     (λ (re c)
       (let ((_ (app debug-trace)))
         (match
          (app regex-empty? re)
          ((#f)
           (match
            (app regex-null? re)
            ((#f)
             (match
              (app eq? c re)
              ((#f)
               (match
                (app regex-atom? re)
                ((#f)
                 (match
                  (app
                   match-seq
                   re
                   (λ (pat1 pat2)
                     (app
                      alt
                      (app seq (app regex-derivative pat1 c) pat2)
                      (app
                       seq
                       (app regex-empty pat1)
                       (app regex-derivative pat2 c)))))
                  ((#f)
                   (match
                    (app
                     match-alt
                     re
                     (λ (pat1 pat2)
                       (app
                        alt
                        (app regex-derivative pat1 c)
                        (app regex-derivative pat2 c))))
                    ((#f)
                     (match
                      (app
                       match-rep
                       re
                       (λ (pat)
                         (app seq (app regex-derivative pat c) (app rep pat))))
                      ((#f) regex-NULL)
                      (c-x c-x)))
                    (c-x c-x)))
                  (c-x c-x)))
                (_ regex-NULL)))
              (_ regex-BLANK)))
            (_ regex-NULL)))
          (_ regex-NULL)))))
    (regex-match
     (λ (pattern data)
       (match
        (app null? data)
        ((#f)
         (app
          regex-match
          (app regex-derivative pattern (app car data))
          (app cdr data)))
        (_ (app regex-empty? (app regex-empty pattern))))))
    (check-expect (λ (check expect) (app equal? check expect))))
   (app
    check-expect
    (app
     regex-match
     (app
      cons
      'seq
      (app
       cons
       'foo
       (app cons (app cons 'rep (app cons 'bar (app nil))) (app nil))))
     (app cons 'foo (app cons 'bar (app nil))))
    (app #f))))
'rsa
'(lettypes
  ((cons car cdr))
  (letrec*
   ((car (λ (car-v) (match car-v ((cons car-c car-d) car-c))))
    (cdr (λ (cdr-v) (match cdr-v ((cons cdr-c cdr-d) cdr-d))))
    (extended-gcd
     (λ (a b)
       (match
        (app = (app modulo a b) 0)
        ((#f)
         (let* ((x:y (app extended-gcd b (app modulo a b)))
                (x (app car x:y))
                (y (app cdr x:y)))
           (app cons y (app - x (app * y (app quotient a b))))))
        (_ (app cons 0 1)))))
    (modulo-inverse (λ (a n) (app modulo (app car (app extended-gcd a n)) n)))
    (totient (λ (p q) (app * (app - p 1) (app - q 1))))
    (square (λ (x) (app * x x)))
    (modulo-power
     (λ (base exp n)
       (match
        (app = exp 0)
        ((#f)
         (match
          (app odd? exp)
          ((#f)
           (app modulo (app square (app modulo-power base (app / exp 2) n)) n))
          (_
           (app
            modulo
            (app * base (app modulo-power base (app - exp 1) n))
            n))))
        (_ 1))))
    (is-legal-public-exponent?
     (λ (e p q)
       (app
        and
        (app < 1 e)
        (app < e (app totient p q))
        (app = 1 (app gcd e (app totient p q))))))
    (private-exponent
     (λ (e p q)
       (match
        (app is-legal-public-exponent? e p q)
        ((#f) (app error "Not a legal public exponent for that modulus."))
        (_ (app modulo-inverse e (app totient p q))))))
    (encrypt
     (λ (m e n)
       (match
        (app > m n)
        ((#f) (app modulo-power m e n))
        (_ (app error "The modulus is too small to encrypt the message.")))))
    (decrypt (λ (c d n) (app modulo-power c d n)))
    (p 41)
    (q 47)
    (n (app * p q))
    (e 7)
    (d (app private-exponent e p q))
    (plaintext 42)
    (ciphertext (app encrypt plaintext e n))
    (decrypted-ciphertext (app decrypt ciphertext d n)))
   (match
    (app not (app = plaintext decrypted-ciphertext))
    ((#f) (app display "RSA success!"))
    (_ (app error "RSA fail!")))))
'sat-1
'(letrec*
  ((phi
    (λ (x1 x2 x3 x4)
      (app
       and
       (app or x1 (app not x2) (app not x3))
       (app or (app not x2) (app not x3))
       (app or x4 x2))))
   (try (λ (f) (app or (app f (app #t)) (app f (app #f)))))
   (sat-solve-4
    (λ (p)
      (app
       try
       (λ (n1)
         (app
          try
          (λ (n2)
            (app try (λ (n3) (app try (λ (n4) (app p n1 n2 n3 n4))))))))))))
  (app sat-solve-4 phi))
'sat-2
'(letrec*
  ((phi
    (λ (x1)
      (λ (x2)
        (λ (x3)
          (λ (x4)
            (λ (x5)
              (λ (x6)
                (λ (x7)
                  (app
                   and
                   (app or x1 x2)
                   (app or x1 (app not x2) (app not x3))
                   (app or x3 x4)
                   (app or (app not x4) x1)
                   (app or (app not x2) (app not x3))
                   (app or x4 x2))))))))))
   (try (λ (f) (app or (app f (app #t)) (app f (app #f)))))
   (sat-solve-7
    (λ (p)
      (app
       try
       (λ (n1)
         (app
          try
          (λ (n2)
            (app
             try
             (λ (n3)
               (app
                try
                (λ (n4)
                  (app
                   try
                   (λ (n5)
                     (app
                      try
                      (λ (n6)
                        (app
                         try
                         (λ (n7)
                           (app
                            (app
                             (app (app (app (app (app p n1) n2) n3) n4) n5)
                             n6)
                            n7))))))))))))))))))
  (app sat-solve-7 phi))
'sat-3
'(letrec*
  ((println (λ (s) (let ((_ (app display s))) (app newline))))
   (phi
    (λ (x1 x2 x3 x4 x5 x6 x7)
      (app
       and
       (app or x1 x2)
       (app or x1 (app not x2) (app not x3))
       (app or x3 x4)
       (app or (app not x4) x1)
       (app or (app not x2) (app not x3))
       (app or x4 x2))))
   (try
    (λ (f)
      (let ((_ (app println "trying")))
        (app or (app f (app #t)) (app f (app #f))))))
   (sat-solve-7
    (λ (p)
      (app
       try
       (λ (n1)
         (app
          try
          (λ (n2)
            (app
             try
             (λ (n3)
               (app
                try
                (λ (n4)
                  (app
                   try
                   (λ (n5)
                     (app
                      try
                      (λ (n6)
                        (app
                         try
                         (λ (n7) (app p n1 n2 n3 n4 n5 n6 n7))))))))))))))))))
  (let ((_ (app display (app sat-solve-7 phi)))) (app newline)))
'tak
'(letrec*
  ((tak
    (λ (x y z)
      (match
       (app not (app < y x))
       ((#f)
        (app
         tak
         (app tak (app - x 1) y z)
         (app tak (app - y 1) z x)
         (app tak (app - z 1) x y)))
       (_ z)))))
  (app tak 32 15 8))
'tic-tac-toe
'(lettypes
  ((cons car cdr)
   (nil)
   (Ze)
   (On)
   (Tw)
   (coord row col)
   (X)
   (O)
   (some v)
   (none)
   (blank)
   (marked xo)
   (win)
   (draw)
   (lose)
   (horizon outcome step-count)
   (move coord horizon)
   (player mark action))
  (letrec*
   ((some-v
     (λ (some-v-v)
       (match
        some-v-v
        ((some some-v-x) x)
        (_ (app error "invalid match for some-v")))))
    (marked? (λ (a) (match a ((marked _) (app #t)) (_ (app #f)))))
    (blank? (λ (a) (match a ((blank) (app #t)) (_ (app #f)))))
    (move-coord
     (λ (move-coord-v)
       (match
        move-coord-v
        ((move move-coord-x _) x)
        (_ (app error "invalid match for move-coord")))))
    (move-horizon
     (λ (move-horizon-v)
       (match
        move-horizon-v
        ((move _ move-horizon-x) x)
        (_ (app error "invalid match for move-horizon")))))
    (is (app cons (app Ze) (app cons (app On) (app cons (app Tw) (app nil)))))
    (mark⁻¹ (λ (ma) (match ma ((X) (app O)) ((O) (app X)))))
    (empty-board (λ (co) (app blank)))
    (board-mark
     (λ (co₀ ma bo)
       (λ (co)
         (match
          (app equal? co₀ co)
          ((#f) (app board-lookup co bo))
          (_ (app marked ma))))))
    (board-lookup (λ (co bo) (app bo co)))
    (marked-with?
     (λ (b co m)
       (match (app b co) ((blank) (app #f)) ((marked m*) (app equal? m m*)))))
    (i⁻¹ (λ (i) (match i ((Ze) (app Tw)) ((On) (app On)) ((Tw) (app Ze)))))
    (ormap
     (λ (f xs)
       (match
        xs
        ((empty) (app #f))
        ((cons x rest-xs) (app or (app f x) (app ormap f rest-xs))))))
    (andmap
     (λ (f xs)
       (match
        xs
        ((empty) (app #t))
        ((cons x rest-xs) (app and (app f x) (app andmap f rest-xs))))))
    (wins?
     (λ (b m)
       (app
        or
        (app
         ormap
         (λ (r) (app andmap (λ (c) (app marked-with? b (app coord r c) m)) is))
         is)
        (app
         ormap
         (λ (c) (app andmap (λ (r) (app marked-with? b (app coord r c) m)) is))
         is)
        (app andmap (λ (rc) (app marked-with? b (app coord rc rc) m)) is)
        (app
         andmap
         (λ (rc) (app marked-with? b (app coord rc (app i⁻¹ rc)) m))
         is))))
    (full?
     (λ (b)
       (app
        andmap
        (λ (r) (app andmap (λ (c) (app marked? (app b (app coord r c)))) is))
        is)))
    (oc<
     (λ (oc₀ oc₁)
       (match
        oc₀
        ((win) (app #f))
        ((draw) (app equal? oc₁ (app win)))
        ((lose) (app not (app equal? oc₁ (app lose)))))))
    (horizon<
     (λ (h₀ h₁)
       (match
        h₀
        ((horizon oc₀ sc₀)
         (match
          h₁
          ((horizon oc₁ sc₁)
           (app
            or
            (app oc< oc₀ oc₁)
            (app and (app equal? oc₀ oc₁) (app < sc₀ sc₁)))))))))
    (horizon-add1
     (λ (h) (match h ((horizon oc sc) (app horizon oc (app + sc 1))))))
    (foldl
     (λ (f acc l)
       (match l ((nil) acc) ((cons x xs) (app foldl f (app f x acc) xs)))))
    (fold/coord
     (λ (f x)
       (app
        foldl
        (λ (r x) (app foldl (λ (c x) (app f (app coord r c) x)) x is))
        x
        is)))
    (min-maybe-move
     (λ (mmo mo₁)
       (match
        mmo
        ((some mo₀)
         (app
          some
          (match
           (app horizon< (app move-horizon mo₀) (app move-horizon mo₁))
           ((#f) mo₁)
           (_ mo₀))))
        ((none) (app some mo₁)))))
    (max-maybe-move
     (λ (mmo mo₁)
       (match
        mmo
        ((some mo₀)
         (app
          some
          (match
           (app horizon< (app move-horizon mo₀) (app move-horizon mo₁))
           ((#f) mo₀)
           (_ mo₁))))
        ((none) (app some mo₁)))))
    (minimax
     (λ (bo this-mark that-mark)
       (app
        fold/coord
        (λ (co mm)
          (match
           (app blank? (app board-lookup co bo))
           ((#f) mm)
           (_
            (let ((bo (app board-mark co this-mark bo)))
              (app
               min-maybe-move
               mm
               (app
                move
                co
                (match
                 (app wins? bo this-mark)
                 ((#f)
                  (match
                   (app full? bo)
                   ((#f)
                    (app
                     horizon-add1
                     (app
                      move-horizon
                      (app some-v (app maximin bo that-mark this-mark)))))
                   (_ (app horizon (app draw) 0))))
                 (_ (app horizon (app lose) 0)))))))))
        (app none))))
    (maximin
     (λ (bo this-mark that-mark)
       (app
        fold/coord
        (λ (co mm)
          (match
           (app blank? (app board-lookup co bo))
           ((#f) mm)
           (_
            (let ((bo (app board-mark co this-mark bo)))
              (app
               max-maybe-move
               mm
               (app
                move
                co
                (match
                 (app wins? bo this-mark)
                 ((#f)
                  (match
                   (app full? bo)
                   ((#f)
                    (app
                     horizon-add1
                     (app
                      move-horizon
                      (app some-v (app minimax bo that-mark this-mark)))))
                   (_ (app horizon (app draw) 0))))
                 (_ (app horizon (app win) 0)))))))))
        (app none))))
    (human-action (λ (bo) (app error 'human-action "not implemented")))
    (make-ai-action
     (λ (ma)
       (λ (bo)
         (app move-coord (app some-v (app maximin bo ma (app mark⁻¹ ma)))))))
    (draw-board! (λ (bo) (app void)))
    (play-turn
     (λ (bo this-play that-play)
       (let ((_ (app draw-board! bo)))
         (match
          this-play
          ((player mark action)
           (let ((co
                  (letrec ((loop
                            (λ ()
                              (let ((co (app action bo)))
                                (match
                                 (app blank? (app board-lookup co bo))
                                 ((#f) (app loop))
                                 (_ co))))))
                    (app loop))))
             (let ((bo (app board-mark co mark bo)))
               (match
                (app wins? bo mark)
                ((#f)
                 (match
                  (app full? bo)
                  ((#f) (app play-turn bo that-play this-play))
                  (_
                   (let ((_ (app draw-board! bo)))
                     (app display "Cat's game.\n")))))
                (_ (let ((_ (app draw-board! bo))) (app void)))))))))))
    (play-game
     (λ (player-one player-two)
       (app play-turn empty-board player-one player-two)))
    (two-player-game
     (λ ()
       (app
        play-game
        (app player (app X) human-action)
        (app player (app O) human-action))))
    (one-player-game
     (λ ()
       (app
        play-game
        (app player (app X) human-action)
        (app player (app O) (app make-ai-action (app O))))))
    (zero-player-game
     (λ ()
       (app
        play-game
        (app player (app X) (app make-ai-action (app X)))
        (app player (app O) (app make-ai-action (app O)))))))
   (app zero-player-game)))
