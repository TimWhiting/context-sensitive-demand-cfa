'structural-rec
'(app (λ (x) (app x x)) (λ (y) (app y y)))
'prim-match
'(letrec ((try (λ (f) (app or (app f (app #t))))))
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
'(let ((x (app cons 1 (app nil)))) (match x ((cons 1 n) n) ((_) x)))
'basic-letstar
'(let* ((a 10) (b a)) a)
'basic-letrec
'(letrec ((a
           (λ (y)
             (match (app equal? y 0) ((#t) y) ((#f) (app a (app - y 1)))))))
   (app a 2))
'app-num
'(let ((x (λ (y) y))) (let ((_ (app x 1))) (app x 2)))
'sat-small
'(letrec ((phi (λ (x1 x2) (app or x1 (app not x2))))
          (try (λ (f) (app or (app f (app #t)) (app f (app #f)))))
          (sat-solve-2
           (λ (p) (app try (λ (n1) (app try (λ (n2) (app p n1 n2))))))))
   (app sat-solve-2 phi))
'tak
'(letrec ((tak
           (λ (x y z)
             (match
              (app not (app < y x))
              ((#t) z)
              ((#f)
               (app
                tak
                (app tak (app - x 1) y z)
                (app tak (app - y 1) z x)
                (app tak (app - z 1) x y)))))))
   (app tak 32 15 8))
'sat-3
'(letrec ((println (λ (s) (let ((_ (app display s))) (app newline))))
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
                                (λ (n7)
                                  (app p n1 n2 n3 n4 n5 n6 n7))))))))))))))))))
   (let ((_ (app display (app sat-solve-7 phi)))) (app newline)))
'sat-2
'(letrec ((phi
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
                                    (app
                                     (app (app (app (app p n1) n2) n3) n4)
                                     n5)
                                    n6)
                                   n7))))))))))))))))))
   (app sat-solve-7 phi))
'sat-1
'(letrec ((phi
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
                   (app
                    try
                    (λ (n3) (app try (λ (n4) (app p n1 n2 n3 n4))))))))))))
   (app sat-solve-4 phi))
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
'kcfa-2
'(app
  (λ (f1) (let ((_ (app f1 (app #t)))) (app f1 (app #f))))
  (λ (x1)
    (app
     (λ (f2) (let ((_ (app f2 (app #t)))) (app f2 (app #f))))
     (λ (x2) (app (λ (z) (app z x1 x2)) (λ (y1 y2) y1))))))
'cpstak
'(letrec ((cpstak
           (λ (x y z)
             (letrec ((tak
                       (λ (x y z k)
                         (match
                          (app not (app < y x))
                          ((#t) (app k z))
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
                                 (app
                                  tak
                                  (app - z 1)
                                  x
                                  y
                                  (λ (v3) (app tak v1 v2 v3 k))))))))))))
               (app tak x y z (λ (a) a))))))
   (app cpstak 32 15 8))
'church
'(letrec ((plus
           (λ (p1)
             (λ (p2) (λ (pf) (λ (x) (app (app p1 pf) (app (app p2 pf) x)))))))
          (mult (λ (m1) (λ (m2) (λ (mf) (app m2 (app m1 mf))))))
          (pred
           (λ (n)
             (λ (rf)
               (λ (rx)
                 (app
                  (app
                   (app n (λ (g) (λ (h) (app h (app g rf)))))
                   (λ (ignored) rx))
                  (λ (id) id))))))
          (sub (λ (s1) (λ (s2) (app (app s2 pred) s1))))
          (church0 (λ (f0) (λ (x0) x0)))
          (church1 (λ (f1) (λ (x1) (app f1 x1))))
          (church2 (λ (f2) (λ (x2) (app f2 (app f2 x2)))))
          (church3 (λ (f3) (λ (x3) (app f3 (app f3 (app f3 x3))))))
          (church0? (λ (z) (app (app z (λ (zx) (app #f))) (app #t))))
          (church=?
           (λ (e1)
             (λ (e2)
               (match
                (app church0? e1)
                ((#t) (app church0? e2))
                ((#f)
                 (match
                  (app church0? e2)
                  ((#t) (app #f))
                  ((#f)
                   (app
                    (app church=? (app (app sub e1) church1))
                    (app (app sub e2) church1))))))))))
   (app
    (app church=? (app (app mult church2) (app (app plus church1) church3)))
    (app
     (app plus (app (app mult church2) church1))
     (app (app mult church2) church3))))
'blur
'(letrec ((id (λ (x) x))
          (blur (λ (y) y))
          (lp
           (λ (a n)
             (match
              (app <= n 1)
              ((#t) (app id a))
              ((#f)
               (let* ((r (app (app blur id) (app #t)))
                      (s (app (app blur id) (app #f))))
                 (app not (app (app blur lp) s (app - n 1)))))))))
   (app lp (app #f) 2))
'ack
'(letrec ((ack
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
'tic-tac-toe
'(lettypes
  ((Ze)
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
  (letrec ((Tw? (λ (a) (match a ((Tw) (app #t)) (_ (app #f)))))
           (On? (λ (a) (match a ((On) (app #t)) (_ (app #f)))))
           (Ze? (λ (a) (match a ((Ze) (app #t)) (_ (app #f)))))
           (coord-row
            (λ (a)
              (match
               a
               ((coord x _) x)
               (_ (app error "invalid match for coord-row")))))
           (coord-col
            (λ (a)
              (match
               a
               ((coord _ x) x)
               (_ (app error "invalid match for coord-col")))))
           (coord? (λ (a) (match a ((coord _ _) (app #t)) (_ (app #f)))))
           (O? (λ (a) (match a ((O) (app #t)) (_ (app #f)))))
           (X? (λ (a) (match a ((X) (app #t)) (_ (app #f)))))
           (none? (λ (a) (match a ((none) (app #t)) (_ (app #f)))))
           (some-v
            (λ (a)
              (match
               a
               ((some x) x)
               (_ (app error "invalid match for some-v")))))
           (some? (λ (a) (match a ((some _) (app #t)) (_ (app #f)))))
           (marked-xo
            (λ (a)
              (match
               a
               ((marked x) x)
               (_ (app error "invalid match for marked-xo")))))
           (marked? (λ (a) (match a ((marked _) (app #t)) (_ (app #f)))))
           (blank? (λ (a) (match a ((blank) (app #t)) (_ (app #f)))))
           (lose? (λ (a) (match a ((lose) (app #t)) (_ (app #f)))))
           (draw? (λ (a) (match a ((draw) (app #t)) (_ (app #f)))))
           (win? (λ (a) (match a ((win) (app #t)) (_ (app #f)))))
           (horizon-outcome
            (λ (a)
              (match
               a
               ((horizon x _) x)
               (_ (app error "invalid match for horizon-outcome")))))
           (horizon-step-count
            (λ (a)
              (match
               a
               ((horizon _ x) x)
               (_ (app error "invalid match for horizon-step-count")))))
           (horizon? (λ (a) (match a ((horizon _ _) (app #t)) (_ (app #f)))))
           (move-coord
            (λ (a)
              (match
               a
               ((move x _) x)
               (_ (app error "invalid match for move-coord")))))
           (move-horizon
            (λ (a)
              (match
               a
               ((move _ x) x)
               (_ (app error "invalid match for move-horizon")))))
           (move? (λ (a) (match a ((move _ _) (app #t)) (_ (app #f)))))
           (player-mark
            (λ (a)
              (match
               a
               ((player x _) x)
               (_ (app error "invalid match for player-mark")))))
           (player-action
            (λ (a)
              (match
               a
               ((player _ x) x)
               (_ (app error "invalid match for player-action")))))
           (player? (λ (a) (match a ((player _ _) (app #t)) (_ (app #f)))))
           (is
            (app
             cons
             (app Ze)
             (app cons (app On) (app cons (app Tw) (app nil)))))
           (mark⁻¹ (λ (ma) (match ma ((X) (app O)) ((O) (app X)))))
           (empty-board (λ (co) (app blank)))
           (board-mark
            (λ (co₀ ma bo)
              (λ (co)
                (match
                 (app equal? co₀ co)
                 ((#t) (app marked ma))
                 ((#f) (app board-lookup co bo))))))
           (board-lookup (λ (co bo) (app bo co)))
           (marked-with?
            (λ (b co m)
              (match
               (app b co)
               ((blank) (app #f))
               ((marked m*) (app equal? m m*)))))
           (i⁻¹
            (λ (i) (match i ((Ze) (app Tw)) ((On) (app On)) ((Tw) (app Ze)))))
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
                (λ (r)
                  (app
                   andmap
                   (λ (c) (app marked-with? b (app coord r c) m))
                   is))
                is)
               (app
                ormap
                (λ (c)
                  (app
                   andmap
                   (λ (r) (app marked-with? b (app coord r c) m))
                   is))
                is)
               (app
                andmap
                (λ (rc) (app marked-with? b (app coord rc rc) m))
                is)
               (app
                andmap
                (λ (rc) (app marked-with? b (app coord rc (app i⁻¹ rc)) m))
                is))))
           (full?
            (λ (b)
              (app
               andmap
               (λ (r)
                 (app andmap (λ (c) (app marked? (app b (app coord r c)))) is))
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
              (match
               l
               ((nil) acc)
               ((cons x xs) (app foldl f (app f acc x) xs)))))
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
                  ((#t) mo₀)
                  ((#f) mo₁))))
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
                  ((#t) mo₁)
                  ((#f) mo₀))))
               ((none) (app some mo₁)))))
           (minimax
            (λ (bo this-mark that-mark)
              (app
               fold/coord
               (λ (co mm)
                 (match
                  (app blank? (app board-lookup co bo))
                  ((#t)
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
                             (app
                              some-v
                              (app maximin bo that-mark this-mark)))))
                          (_ (app horizon (app draw) 0))))
                        (_ (app horizon (app lose) 0)))))))
                  ((#f) mm)))
               (app none))))
           (maximin
            (λ (bo this-mark that-mark)
              (app
               fold/coord
               (λ (co mm)
                 (match
                  (app blank? (app board-lookup co bo))
                  ((#t)
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
                             (app
                              some-v
                              (app minimax bo that-mark this-mark)))))
                          (_ (app horizon (app draw) 0))))
                        (_ (app horizon (app win) 0)))))))
                  ((#f) mm)))
               (app none))))
           (human-action
            (λ (bo) (app error (app quote human-action) "not implemented")))
           (make-ai-action
            (λ (ma)
              (λ (bo)
                (app
                 move-coord
                 (app some-v (app maximin bo ma (app mark⁻¹ ma)))))))
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
                                        ((#t) co)
                                        ((#f) (app loop)))))))
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
